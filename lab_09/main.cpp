#include <iostream>
#include <vector>
#include <cstdint>
#include <opencv2/opencv.hpp>

#include <emmintrin.h>

const uint8_t alter_val = 128;
const uint8_t alter_constant[16] = {alter_val, alter_val, alter_val, alter_val, alter_val, alter_val, alter_val, alter_val, alter_val, alter_val, alter_val, alter_val, alter_val, alter_val, alter_val, alter_val};

// const float alter_constant = 1;

// const float alter_constants[3] = {0.5f, 0.5f, 0.5f};
// const float alter_constants[3] = {1, 1, 1};

void cpp_alter_image(uint8_t* image_data, size_t width, size_t height)
{
    for (size_t i = 0; i < width * height * 3; i += 3)
    {
        image_data[i]     -= alter_val;
        image_data[i + 1] -= alter_val;
        image_data[i + 2] -= alter_val;
    }
}

void asm_alter_image(uint8_t* image_data, size_t width, size_t height)
{
    size_t total_pixels = width * height;

    for (size_t i = 0; i < total_pixels * 3; i += 16)
    {
        __asm__ volatile (
            "MOVDQU (%[src]), %%xmm1\n\t" 

            "XORPD %%xmm0, %%xmm0\n\t"
            "MOVDQU %[alter_const], %%xmm0\n\t"
            "PSUBB %%xmm0, %%xmm1\n\t"

            // "XORPD %%xmm2, %%xmm2\n\t"
            // "PSUBB %%xmm0, %%xmm2\n\t"
            // "PCMPGTB %%xmm1, %%xmm2\n\t"
            // "PAND %%xmm2, %%xmm1\n\t"

            "MOVDQU %%xmm1, (%[dest])\n\t"
            :
            : [src] "r" (image_data + i), [dest] "r" (image_data + i), [alter_const] "m" (alter_constant)
            : "%xmm1", "%xmm0", "%xmm2"
        );
    }

    for (size_t i = total_pixels * 3 - (total_pixels * 3) % 16; i < total_pixels * 3; i += 3)
    {
        image_data[i]     -= alter_val;
        image_data[i + 1] -= alter_val;
        image_data[i + 2] -= alter_val;
    }
}

int main()
{
    cv::Mat image = cv::imread("img.png", cv::IMREAD_COLOR);
    if (image.empty())
    {
        std::cerr << "Failed to open image file\n";
        return 1;
    }

    size_t width = image.cols;
    size_t height = image.rows;

    uint8_t *image_data = static_cast<uint8_t*>(malloc(width * height * 3));
    if (!image_data)
    {
        std::cerr << "Failed to allocate memory\n";
        return 1;
    }

    size_t idx = 0;
    for (size_t y = 0; y < height; ++y)
    {
        const uint8_t* row_ptr = image.ptr<uint8_t>(y);
        for (size_t x = 0; x < width * 3; ++x)
        {
            image_data[idx++] = row_ptr[x];
        }
    }

    asm_alter_image(image_data, width, height);

    idx = 0;
    for (size_t y = 0; y < height; ++y)
    {
        uint8_t* row_ptr = image.ptr<uint8_t>(y);
        for (size_t x = 0; x < width * 3; ++x)
        {
            row_ptr[x] = image_data[idx++];
        }
    }

    free(image_data);

    cv::imwrite("dimg.png", image);
    std::cout << "altered image saved successfully.\n";

    return 0;
}
